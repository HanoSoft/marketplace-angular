import {Component, Inject, OnDestroy, OnInit} from '@angular/core';
import 'rxjs/add/observable/of';
import {Observable} from 'rxjs/Observable';
import {Subscription} from 'rxjs/Subscription';
import {ProductService} from './services/product.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent  implements OnInit, OnDestroy {
    subscribtion: Subscription ;
    isAuth: string;
    basket = 0 ;
    constructor( ) {
    }
    ngOnInit() {
        console.log(localStorage.getItem('isAuth'));
        const auth = Observable.of(localStorage.getItem('isAuth'));
        this.subscribtion = auth.subscribe(
            (value) => {
                this.isAuth = value;
            });
    }
    ngOnDestroy(): void {
    }

}
