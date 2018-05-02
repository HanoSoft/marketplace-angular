import { Component, OnInit } from '@angular/core';
import {ShopingService} from '../services/shoping.service';
import {Subject} from 'rxjs/Subject';
import {Subscription} from 'rxjs/Subscription';

@Component({
  selector: 'app-basket-list',
  templateUrl: './basket-list.component.html',
  styleUrls: ['./basket-list.component.scss']
})
export class BasketListComponent  {
    public itemCount;
    public subscription: Subscription;
    private val: Subject <any>;
    products;
    total;
    quantity = 1;
    constructor(private _basketService: ShopingService) {
        this.val = _basketService.itemCountSource;
        this.itemCount = 0;
        this.subscription = _basketService.itemCount$.subscribe(
            data => {
                this.itemCount = data;
            });
        this.products = this._basketService.getProducts();
        this.total = this._basketService.totalPrice;
    }

    public onDelete(id, price) {
        this._basketService.remove(id, price);
        this.products = this._basketService.getProducts();
        this.total = this._basketService.totalPrice;
    }
    public onAdd(price) {
        this.quantity++;
        this.total = this.total + price;
    }
    public onMinus(price) {
        this.quantity--;
        this.total = this.total - price;
    }
}
