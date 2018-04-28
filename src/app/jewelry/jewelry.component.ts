import { Component, OnInit } from '@angular/core';
import {BrandService} from '../services/brand.service';
import {Subscription} from 'rxjs/Subscription';

@Component({
  selector: 'app-jewelry',
  templateUrl: './jewelry.component.html',
  styleUrls: ['./jewelry.component.scss']
})
export class JewelryComponent implements OnInit {
    brands: any[];
    brandSubscription: Subscription;
    constructor( private brandService: BrandService) {
    }

    ngOnInit() {
        this.brandSubscription = this.brandService.brandSubject.subscribe(
            (brands: any[]) => {
                this.brands = brands;
            }
        );
        this.brandService.emitBrandSubject();
        this.onFetch() ;
    }
    onFetch() {
        this.brandService.getBrands();
    }
}
