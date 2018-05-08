import { Injectable } from '@angular/core';
import {BehaviorSubject} from 'rxjs/BehaviorSubject';
import {HttpClient} from '@angular/common/http';
import {Item} from '../models/Item.model';
import {Order} from '../models/Order.model';

@Injectable()
export class ShopingService {
    private itemCount: number;
     itemCountSource = new BehaviorSubject(0);
    itemCount$ = this.itemCountSource.asObservable();
    totalPrice: number;
    private products = [];
    constructor(private httpClient: HttpClient) {
        this.itemCount = 0;
        this.itemCountSource.next(0);
        this.totalPrice = 0.0;
    }
    saveToServer(body: any) {
        const customerId = localStorage.getItem('id');
        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId;
        const b = JSON.stringify(body);
        this.httpClient.post(url, b, {
            headers: {'Content-Type': 'application/json'}
        })
            .subscribe(
                () => {}, (error) => {console.log( b + 'erreur' + error); }
            );
    }
    public saveItems () {
        const items = [] ;
        for (const product of this.products) {
            const item = new Item(product.id, product.quantity);
            items.push(item);
        }
        this.saveToServer( new Order(this.totalPrice, items));
    }
    public AddToBasket(id, price, name, image, quantity) {
        this.itemCount++;
        this.itemCountSource.next(this.itemCount);
        this.totalPrice += price * quantity;
        // initialise the product
        const productObject = {
            id: '',
            product_name: '',
            price: '',
            image: '',
            quantity: ''
        };
        productObject.id = id;
        productObject.product_name = name;
        productObject.price = price;
        productObject.image = image;
        productObject.quantity = quantity;
        this.products.push(productObject);
    }
    public getProducts () {
       return this.products;
    }

    public remove (id, price) {
        const productIndexToRemove = this.products.findIndex(
            (product) => {
                if (product.id === id) {
                    this.totalPrice -= product.quantity * price;
                    return true;
                }
            }
        );
        console.log (productIndexToRemove);
        this.itemCount--;
        this.itemCountSource.next(this.itemCount);
        this.products.splice(productIndexToRemove, 1);
    }
    public increaseQuantity(id, price) {
        const productIndexToRemove = this.products.findIndex(
            (product) => {
                if (product.id === id) {
                    product.quantity ++;
                    return true;
                }
            }
        );
        this.totalPrice += price;
    }
    public decreaseQuantity(id, price) {
        const productIndexToRemove = this.products.findIndex(
            (product) => {
                if (product.id === id) {
                    product.quantity --;
                    return true;
                }
            }
        );
        this.totalPrice -= price;
    }
}
