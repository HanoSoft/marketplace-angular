import { Component, OnInit } from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {BrandService} from '../services/brand.service';

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.scss']
})
export class ProductListComponent implements OnInit {
    brand;
    idc ;
    id;
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/brand/';
constructor(private brandService: BrandService, private router: ActivatedRoute, private route: Router) {
        this.id = this.router.snapshot.params['id'];
        this.idc = +this.router.snapshot.params['idc'];
        this.brand = this.brandService.getBrand(+this.id);
    }
    ngOnInit(): void {
        }
  ngOnRedirect(idc: number) {
      this.route.navigate(['/', this.id, idc]);
      this.id = this.router.snapshot.params['id'];
      this.idc = idc;
      this.brand = this.brandService.getBrand(+this.id);
  }
}
