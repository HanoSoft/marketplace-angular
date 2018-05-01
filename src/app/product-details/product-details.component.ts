import {Component , OnInit} from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {BrandService} from '../services/brand.service';
import {ShopingService} from '../services/shoping.service';

@Component({
  selector: 'app-product-details',
  templateUrl: './product-details.component.html',
  styleUrls: ['./product-details.component.scss']
})
export class ProductDetailsComponent implements OnInit {
    brand;
    idc ;
    id;
    idp;
    urlBrand = 'http://localhost:8888/pfe_marketplace/web/uploads/brand/';
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';
    constructor(private brandService: BrandService, private router: ActivatedRoute, private shoping: ShopingService) {
        this.id = this.router.snapshot.params['id'];
        this.idc = +this.router.snapshot.params['idc'];
         this.idp = this.router.snapshot.params['idp'];
        this.brand = this.brandService.getBrand(+this.id);
    }
    ngOnInit(): void {
    }
    onAdd(id, price , name, image) {
        this.shoping.AddToBasket(id, price , name, image);
    }
}
