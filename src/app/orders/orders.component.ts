import { Component, OnInit } from '@angular/core';
import {Subscription} from 'rxjs/Subscription';
import {ShopingService} from '../services/shoping.service';
import {BrandService} from '../services/brand.service';

@Component({
  selector: 'app-orders',
  templateUrl: './orders.component.html',
  styleUrls: ['./orders.component.scss']
})
export class OrdersComponent implements OnInit {
   orders: any[];
   orderSubscription: Subscription;
   constructor(private shopingService: ShopingService, private brandService: BrandService) { }
    ngOnInit() {
        this.orderSubscription = this.shopingService.orderSubject.subscribe(
            (orders: any[]) => {
                this.orders = orders;
            }
        );
        this.shopingService.emitOrderSubject();
        this.shopingService.getOrders();
    }
    onDelete(id) {
        this.shopingService.cancelOrder(id);
    }
    onShow(){

    }
}
