import {Component, OnDestroy, OnInit} from '@angular/core';
import {Router} from '@angular/router';
import {ShopingService} from '../services/shoping.service';
import {Shoping} from '../models/Shoping';
import {Subscription} from 'rxjs/Subscription';
import {getTemplate} from 'codelyzer/util/ngQuery';
import {Subject} from 'rxjs/Subject';


@Component({
  selector: 'app-top-nav',
  templateUrl: './top-nav.component.html',
  styleUrls: ['./top-nav.component.scss']
})
export class TopNavComponent {
    public itemCount;
    public subscription: Subscription;
    private val: Subject <any>;
    constructor(private router: Router, private _basketService: ShopingService) {
        this.val = _basketService.itemCountSource;
        this.itemCount = 0;
        this.subscription = _basketService.itemCount$.subscribe(
            data => {
                this.itemCount = data;
            });
    }
    onLogOut() {
        localStorage.clear();
        window.location.reload();
        this.router.navigate(['auth']);
    }
}
