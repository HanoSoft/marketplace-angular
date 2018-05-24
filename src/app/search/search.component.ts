import { Component, OnInit } from '@angular/core';
import {BrandService} from '../services/brand.service';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.scss']
})
export class SearchComponent implements OnInit {
products;
  constructor(private brandService: BrandService) { }
  ngOnInit() {
      const search = localStorage.getItem('search');
    this.products = this.brandService.getProducts(search);
  }

}
