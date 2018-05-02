import { Injectable } from '@angular/core';
import {BehaviorSubject} from 'rxjs/BehaviorSubject';

@Injectable()
export class ShopingService {
    private itemCount: number;
     itemCountSource = new BehaviorSubject(0);
    itemCount$ = this.itemCountSource.asObservable();
    totalPrice: number;
    private products = [];
    constructor() {
        this.itemCount = 0;
        this.itemCountSource.next(0);
        this.totalPrice = 0.0;
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
                    return true;
                }
            }
        );
        console.log (productIndexToRemove);
        this.itemCount--;
        this.itemCountSource.next(this.itemCount);
        this.totalPrice -= price;
        this.products.splice(productIndexToRemove, 1);
    }
}
