import { Injectable } from '@angular/core';
import {Subject} from 'rxjs/Subject';

@Injectable()
export class ShopingService {
    ProductSubject = new Subject<any[]>();
    private shopingproducts = [
        {id: 1},
        {id: 2}
    ];
  constructor() { }
    public getShopingProducts () {
       return this.shopingproducts;
    }
    public add(id) {
        this.shopingproducts.push(id);
    }
}
