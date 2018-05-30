import {Component, Input, OnInit} from '@angular/core';
import {Subscription} from 'rxjs/Subscription';
import {BrandService} from '../services/brand.service';
import {NgProgress} from 'ngx-progressbar';

@Component({
  selector: 'app-brand-list',
  templateUrl: './brand-list.component.html',
  styleUrls: ['./brand-list.component.scss']
})
export class BrandListComponent implements OnInit {
    brands: any[];
    brandSubscription: Subscription;
    isLoading = true;
    constructor( private brandService: BrandService, public ngProgress: NgProgress) {
    }
    ngOnInit() {
        this.ngProgress.start();
        this.brandSubscription = this.brandService.brandSubject.subscribe(
            (brands: any[]) => {
                this.brands = brands;
                this.ngProgress.done();
            }
        );
        this.brandService.emitBrandSubject();
            this.onFetch() ;
        this.isLoading = false;
    }
    onFetch() {
        this.brandService.getBrands();
    }
}
