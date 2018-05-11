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
    constructor(private _basketService: ShopingService) {
        this._basketService.initialse();
        this.products = this._basketService.getProducts();
        this.val = _basketService.itemCountSource;
        this.itemCount = 0;
        this.subscription = _basketService.itemCount$.subscribe(
            data => {
                this.itemCount = data;
            });
        this.total = this._basketService.totalPrice;
    }

    public onDelete(id, price) {
        this._basketService.remove(id, price);
        this.products = this._basketService.getProducts();
        this.total = this._basketService.totalPrice;
    }
    public onAdd(id, price) {
     this._basketService.increaseQuantity(id, price);
        this.total = this._basketService.totalPrice;
    }
    public onDecrease(id, price) {
        this._basketService.decreaseQuantity(id, price);
        this.total = this._basketService.totalPrice;
    }
}
