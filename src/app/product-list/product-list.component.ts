import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {BrandService} from '../services/brand.service';

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.scss']
})
export class ProductListComponent implements OnInit {
    brand;
    idc ;
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/brand/';
    constructor(private brandService: BrandService, private route: ActivatedRoute) {
        const id = this.route.snapshot.params['id'];
         this.idc = +this.route.snapshot.params['idc'];
        this.brand = this.brandService.getBrand(+id);
    }
  ngOnInit() {
  }

}