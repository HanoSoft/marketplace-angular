import {Component, OnDestroy, OnInit} from '@angular/core';
import {Router} from '@angular/router';
import {ShopingService} from '../services/shoping.service';
import {Subscription} from 'rxjs/Subscription';
import {Subject} from 'rxjs/Subject';
import {Observable} from 'rxjs/Observable';
import {NgForm} from '@angular/forms';


@Component({
  selector: 'app-top-nav',
  templateUrl: './top-nav.component.html',
  styleUrls: ['./top-nav.component.scss']
})
export class TopNavComponent implements OnInit {
    subscribtion: Subscription ;
    public itemCount;
    public subscription: Subscription;
    private val: Subject <any>;
    isAuth: string;
    constructor(private router: Router, private _basketService: ShopingService) {
        this._basketService.initialse();
        this.val = _basketService.itemCountSource;
        this.subscription = _basketService.itemCount$.subscribe(
            data => {
                this.itemCount = data;
            });
    }
    onLogOut() {
        localStorage.clear();
        this.router.navigate(['']);
        window.location.reload();
    }
    ngOnInit(): void {
        const auth = Observable.of(localStorage.getItem('isAuth'));
        this.subscribtion = auth.subscribe(
            (value) => {
                this.isAuth = value;
            });
    }
    onSubmit(form: NgForm) {
       const search = form.value['search'];
    }
    onSearch(form: NgForm) {
        const search = form.value['search'];
        localStorage.setItem('search', search);
        this.router.navigate(['/search']);
    }
}
