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
   products: any [];
   constructor(private shopingService: ShopingService, private brandService: BrandService) { }
    ngOnInit() {
        this.orderSubscription = this.shopingService.orderSubject.subscribe(
            (orders: any[]) => {
                this.orders = orders;
            }
        );
        this.shopingService.emitOrderSubject();
        this.shopingService.getOrders();
        for (const order of this.orders) {
            for (const item of order.items) {
                this.products.push(this.brandService.getProduct(+item.product));
            }
        }
    }
    onDelete(id) {
        this.shopingService.cancelOrder(id);
    }
}
