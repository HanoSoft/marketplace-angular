import { Component, OnInit } from '@angular/core';
import {Subscription} from 'rxjs/Subscription';
import {BrandService} from '../services/brand.service';

@Component({
  selector: 'app-high-tec',
  templateUrl: './high-tec.component.html',
  styleUrls: ['./high-tec.component.scss']
})
export class HighTecComponent implements OnInit {

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
