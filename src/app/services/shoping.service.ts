import { Injectable } from '@angular/core';
import {BehaviorSubject} from 'rxjs/BehaviorSubject';
import {HttpClient} from '@angular/common/http';
import {Item} from '../models/Item.model';
import {Order} from '../models/Order.model';
import {Subject} from 'rxjs/Subject';

@Injectable()
export class ShopingService {
    private itemCount: number;
     itemCountSource = new BehaviorSubject(0);
    itemCount$ = this.itemCountSource.asObservable();
    totalPrice: number;
    orders = [];
    delivery = [];
    orderSubject = new Subject<any[]>();
    deliverySubject = new Subject<any[]>();
    private products = [];
    constructor(private httpClient: HttpClient) {
        this.itemCount = 0;
        this.itemCountSource.next(0);
        this.totalPrice = 0.0;
    }
    public emitDelivrySubject() {
        this.deliverySubject.next(this.delivery.slice());
    }
    public getDeliveries() {
        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/delivery').subscribe(
            (response) => {this.delivery = response;
                this.emitDelivrySubject();
            },
            (error) => {console.log('Erreur ! :' + error); }
        );
    }
    saveToServer(body: any) {
        const customerId = localStorage.getItem('id');
        const deliveryId = localStorage.getItem('delivery');
        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId + '/' + deliveryId;
        const b = JSON.stringify(body);
        this.httpClient.post(url, b, {
            headers: {'Content-Type': 'application/json'}
        })
            .subscribe(
                () => {}, (error) => {console.log( b + 'erreur' + error); }
            );
        this.destroy();
        this.products = [];
        this.itemCount = 0;
        this.itemCountSource.next(0);
        this.totalPrice = 0.0;
    }
    public saveItems () {
        const items = [] ;
        for (const product of this.products) {
            const item = new Item(product.id, product.quantity, product.size);
            items.push(item);
        }
        this.saveToServer( new Order(this.totalPrice, items));
    }
    public AddToBasket(id, price, name, image, quantity, size) {
        this.itemCount++;
        this.itemCountSource.next(this.itemCount);
        this.totalPrice += price * quantity;
        // initialise the product
        const productObject = {
            id: '',
            product_name: '',
            price: '',
            image: '',
            quantity: '',
            size: ''
        };
        productObject.id = id;
        productObject.product_name = name;
        productObject.price = price;
        productObject.image = image;
        productObject.quantity = quantity;
        productObject.size = size;
        this.products.push(productObject);
       this.storeData();
    }
    public getProducts () {
       return this.products;
    }
    public storeData() {
        localStorage.setItem('shopingList', JSON.stringify(this.products));
        localStorage.setItem('total', this.totalPrice.toString());
        localStorage.setItem('itemCount', this.itemCount.toString());
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
        this.storeData();
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
        this.storeData();
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
        this.storeData();
    }
    public initialse() {
        if (localStorage.getItem('itemCount')) {
            this.products = JSON.parse(localStorage.getItem('shopingList'));
            this.totalPrice = +localStorage.getItem('total');
            this.itemCount = +localStorage.getItem('itemCount');
            this.itemCountSource.next(this.itemCount);
        }
    }
    public destroy() {
        localStorage.removeItem('shopingList');
        localStorage.removeItem('total');
        localStorage.removeItem('itemCount');
    }
    public emitOrderSubject() {
        this.orderSubject.next(this.orders.slice());
    }
    public getOrders() {
        const customerId = localStorage.getItem('id');
        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId).subscribe(
            (response) => {this.orders = response;
                this.emitOrderSubject();
            },
            (error) => {console.log('Erreur ! :' + error); }
        );
    }
    public cancelOrder(id) {
        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/cancel/' + id;
        this.httpClient.put(url, [], {
            headers: {'Content-Type': 'application/json'}
        })
            .subscribe(
                () => {}, (error) => {console.log( 'erreur' + error); }
            );
    }
    getOrder(id: number) {
        const order = this.orders.find((orderObject) => {
            return orderObject.id === id; });
        console.log('ok' + id);
        return order;
    }
}
