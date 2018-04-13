import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';


import { AppComponent } from './app.component';
import { TopNavComponent } from './top-nav/top-nav.component';
import {RouterModule, Routes} from '@angular/router';
import { HomeComponent } from './home/home.component';
import {HttpClientModule} from '@angular/common/http';
import {BrandService} from './services/brand.service';
import { BrandListComponent } from './brand-list/brand-list.component';
import { BrandComponent } from './brand/brand.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import { FooterComponent } from './footer/footer.component';
import { SingleBrandComponent } from './single-brand/single-brand.component';
import { HorizontalTabComponent } from './horizontal-tab/horizontal-tab.component';
import { NotFoundComponent } from './not-found/not-found.component';
import { ProductListComponent } from './product-list/product-list.component';
import { ClothesComponent } from './clothes/clothes.component';
import { BeautyComponent } from './beauty/beauty.component';
import { ProductComponent } from './product/product.component';
import { CategoryComponent } from './category/category.component';
import { BrandAllProductComponent } from './brand-all-product/brand-all-product.component';
import { HighTecComponent } from './high-tec/high-tec.component';



const appRoutes: Routes = [
    { path: '', component: HomeComponent},
    { path: 'clothes', component: ClothesComponent},
    { path: 'clothes/:id', component: SingleBrandComponent},
    { path: 'beauty', component: BeautyComponent},
    { path: 'beauty/:id', component: SingleBrandComponent},
    { path: 'HighTec', component: HighTecComponent},
    { path: 'HighTec/:id', component: SingleBrandComponent},
    { path: ':id', component: SingleBrandComponent},
    { path: ':id/all', component: BrandAllProductComponent},
    { path: ':id/:idc', component: ProductListComponent},
    {path: 'not-found', component: NotFoundComponent},
    {path: '**', redirectTo: '/not-found'},
];

@NgModule({
  declarations: [
    AppComponent,
    TopNavComponent,
    HomeComponent,
    BrandListComponent,
    BrandComponent,
    FooterComponent,
    SingleBrandComponent,
    HorizontalTabComponent,
    NotFoundComponent,
    ProductListComponent,
    ClothesComponent,
    BeautyComponent,
    ProductComponent,
    CategoryComponent,
    BrandAllProductComponent,
    HighTecComponent,

  ],
  imports: [
    BrowserModule,
    HttpClientModule,
      FormsModule,
      ReactiveFormsModule,
    RouterModule.forRoot(appRoutes)
  ],
  providers: [
      BrandService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
