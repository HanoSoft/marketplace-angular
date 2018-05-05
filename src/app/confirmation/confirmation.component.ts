import { Component, OnInit } from '@angular/core';
import {ShopingService} from '../services/shoping.service';
import {OrderService} from '../services/order.service';
import {Order} from '../models/Order.model';

@Component({
  selector: 'app-confirmation',
  templateUrl: './confirmation.component.html',
  styleUrls: ['./confirmation.component.scss']
})
export class ConfirmationComponent implements OnInit {
  pay = true;
  constructor(private shopingService: ShopingService, private orderService: OrderService) { }

  ngOnInit() {
      const order = new Order(this.shopingService.totalPrice);
      this.orderService.addOrder(order);
    this.shopingService.saveItems();
  }

}
