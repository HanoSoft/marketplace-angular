import {Component, Input, OnInit} from '@angular/core';

@Component({
  selector: 'app-product',
  templateUrl: './product.component.html',
  styleUrls: ['./product.component.scss']
})
export class ProductComponent implements OnInit {
    @Input() id: number;
    @Input() deleted: boolean;
    @Input()  productName: string ;
    @Input() description: string;
    @Input() price: number;
    @Input() quantity: number ;
    @Input() images = [];
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';
  constructor() { }

  ngOnInit() {
  }

}
