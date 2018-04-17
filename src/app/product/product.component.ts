import {Component, Input, OnInit} from '@angular/core';
import {ShopingService} from '../services/shoping.service';
import {Router} from '@angular/router';

@Component({
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
  constructor(private shoping: ShopingService, private route: Router) { }

  ngOnInit() {
      this.products = this.shoping.getShopingProducts();
  }
  onAdd(id) {
      this.shoping.add(id);
  }

}
