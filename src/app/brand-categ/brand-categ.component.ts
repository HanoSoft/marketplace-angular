import { Component, OnInit } from '@angular/core';
import {BrandService} from '../services/brand.service';
import {ActivatedRoute} from '@angular/router';

@Component({
  selector: 'app-brand-categ',
  templateUrl: './brand-categ.component.html',
  styleUrls: ['./brand-categ.component.scss']
})
export class BrandCategComponent implements OnInit {
    brand ;
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/brand/';
    constructor(private brandService: BrandService, private route: ActivatedRoute) {
        const id = this.route.snapshot.params['id'];
        this.brand = this.brandService.getBrand(+id);
    }
  ngOnInit() {
  }

}
