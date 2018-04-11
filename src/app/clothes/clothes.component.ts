import { Component, OnInit } from '@angular/core';
import {BrandService} from '../services/brand.service';
import {ActivatedRoute} from '@angular/router';
import {Subscription} from 'rxjs/Subscription';

@Component({
  selector: 'app-clothes',
  templateUrl: './clothes.component.html',
  styleUrls: ['./clothes.component.scss']
})
export class ClothesComponent implements OnInit {
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
