import {Component, Input, OnInit} from '@angular/core';
import {ShopingService} from '../services/shoping.service';

@Component({
  selector: 'app-top-nav',
  templateUrl: './top-nav.component.html',
  styleUrls: ['./top-nav.component.scss']
})
export class TopNavComponent implements OnInit {
    products = [] ;
  constructor(private shoping: ShopingService) { }
  ngOnInit() {
      this.products = this.shoping.getShopingProducts();
  }

}
