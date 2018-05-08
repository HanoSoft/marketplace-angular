import { Injectable } from '@angular/core';
import {Subject} from 'rxjs/Subject';
import {HttpClient} from '@angular/common/http';
import {Order} from '../models/Order.model';

@Injectable()
export class OrderService {
    orderSubject = new Subject<any[]>();
    private orders = [] ;
    constructor(private httpClient: HttpClient) { }
    public emitOrderSubject() {
        this.orderSubject.next(this.orders.slice());
    }
    public getOrdersFromServer () {
        const customerId = localStorage.getItem('id');
        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId).subscribe(
            (response) => {this.orders = response;
                this.emitOrderSubject();
            },
            (error) => {console.log('Erreur ! :' + error); }
        );
    }
    saveOrderToServer(body: any) {
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
    addOrder(order: Order) {
        this.orders.push(order);
        this.emitOrderSubject();
        this.saveOrderToServer(order);
    }
    getOrders() {
        return this.orders[0].id;
    }
}
