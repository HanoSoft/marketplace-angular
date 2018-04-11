import { Component, OnInit } from '@angular/core';
import {Subscription} from 'rxjs/Subscription';
import {BrandService} from '../services/brand.service';

@Component({
  selector: 'app-beauty',
  templateUrl: './beauty.component.html',
  styleUrls: ['./beauty.component.scss']
})
export class BeautyComponent implements OnInit {
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
