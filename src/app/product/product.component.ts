
import {ShopingService} from '../services/shoping.service';
import {Router} from '@angular/router';
import {Component, Input, OnInit} from '@angular/core';
import {TopNavComponent} from '../top-nav/top-nav.component';
import {Shoping} from '../models/Shoping';

@Component({
    providers: [TopNavComponent ],
  selector: 'app-product',
  templateUrl: './product.component.html',
  styleUrls: ['./product.component.scss']
})
export class ProductComponent implements OnInit {
    products = [] ;
    @Input() id: number;
    @Input() deleted: boolean;
    @Input()  productName: string ;
    @Input() description: string;
    @Input() price: number;
    @Input() quantity: number ;
    @Input() images = [];
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';
  constructor(private shoping: ShopingService, private route: Router ) { }
  ngOnInit() {
  }
  onAdd(id, price , name, image) {
      this.shoping.AddToBasket(id, price , name, image);
  }
}
