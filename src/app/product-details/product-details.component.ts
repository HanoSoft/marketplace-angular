import {Component , OnInit} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {BrandService} from '../services/brand.service';
import {ProductService} from '../services/product.service';
import {Subscription} from 'rxjs/Subscription';

@Component({
  selector: 'app-product-details',
  templateUrl: './product-details.component.html',
  styleUrls: ['./product-details.component.scss']
})
export class ProductDetailsComponent implements OnInit {
    product;
    productSubscription: Subscription;
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';
    urlBrand = 'http://localhost:8888/pfe_marketplace/web/uploads/brand/';
    constructor(private productService: ProductService, private route: ActivatedRoute) {
        this.productService.getProducts();
        const idp = this.route.snapshot.params['idp'];
        this.product = this.productService.getProduct(+idp);
    }
  ngOnInit() {
  }
}
