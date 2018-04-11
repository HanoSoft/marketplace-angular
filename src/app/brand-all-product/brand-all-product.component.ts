import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {BrandService} from '../services/brand.service';

@Component({
  selector: 'app-brand-all-product',
  templateUrl: './brand-all-product.component.html',
  styleUrls: ['./brand-all-product.component.scss']
})
export class BrandAllProductComponent implements OnInit {
    brand ;
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/brand/';
    constructor(private brandService: BrandService, private route: ActivatedRoute) {
        const id = this.route.snapshot.params['id'];
        this.brand = this.brandService.getBrand(+id);
    }
  ngOnInit() {
  }

}
