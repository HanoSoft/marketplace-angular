import { Component, OnInit } from '@angular/core';
import {Subscription} from 'rxjs/Subscription';
import {ShopingService} from '../services/shoping.service';

@Component({
  selector: 'app-payment',
  templateUrl: './payment.component.html',
  styleUrls: ['./payment.component.scss']
})
export class PaymentComponent implements OnInit {
    delivery: any[];
    deliverySubscription: Subscription;
    constructor(private shopingService: ShopingService) { }

    ngOnInit() {
        this.deliverySubscription = this.shopingService.deliverySubject.subscribe(
            (delivery: any[]) => {
                this.delivery = delivery;
            }
        );
        this.shopingService.emitDelivrySubject();
        this.shopingService.getDeliveries();
    }
    onChecked(id) {
        localStorage.removeItem('delivery');
        localStorage.setItem('delivery', id);
    }
}
