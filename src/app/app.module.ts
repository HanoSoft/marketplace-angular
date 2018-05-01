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
import { HighTecComponent } from './high-tec/high-tec.component';
import { ProductDetailsComponent } from './product-details/product-details.component';
import {ShopingService} from './services/shoping.service';
import { BasketListComponent } from './basket-list/basket-list.component';
import { SignupComponent } from './signup/signup.component';
import {CustomerService} from './services/customer.service';
import {AuthGuard} from './services/auth-guard.service';
import { SigninComponent } from './signin/signin.component';
import { ContainerComponent } from './container/container.component';
import { CustomerProfileComponent } from './customer-profile/customer-profile.component';
import { JewelryComponent } from './jewelry/jewelry.component';



const appRoutes: Routes = [
    { path: 'auth', component: SigninComponent},
    { path: 'signup', component: SignupComponent},
    { path: 'profile', canActivate: [AuthGuard], component: CustomerProfileComponent },
    { path: '', canActivate: [AuthGuard], component: HomeComponent},
    /*basket-list*/
    { path: 'basket', canActivate: [AuthGuard], component: BasketListComponent},
    { path: 'clothes', canActivate: [AuthGuard], component: ClothesComponent},
    { path: 'beauty', canActivate: [AuthGuard],  component: BeautyComponent},
    { path: 'HighTec', canActivate: [AuthGuard], component: HighTecComponent},
    { path: 'jewelry', canActivate: [AuthGuard], component: JewelryComponent},
    /*single brand*/
    { path: ':id', canActivate: [AuthGuard], component: SingleBrandComponent},
    { path: 'clothes/:id', canActivate: [AuthGuard], component: SingleBrandComponent},
    { path: 'beauty/:id', canActivate: [AuthGuard], component: SingleBrandComponent},
    { path: 'HighTec/:id', canActivate: [AuthGuard], component: SingleBrandComponent},
    { path: 'jewelry/:id', canActivate: [AuthGuard], component: SingleBrandComponent},
    /*product list */
    { path: ':id/all', canActivate: [AuthGuard], component: ProductListComponent},
    { path: ':id/:idc', canActivate: [AuthGuard], component: ProductListComponent},
    { path: 'clothes/:id/all', canActivate: [AuthGuard], component: ProductListComponent},
    { path: 'clothes/:id/:idc', canActivate: [AuthGuard], component: ProductListComponent},
    { path: 'beauty/:id/all', canActivate: [AuthGuard], component: ProductListComponent},
    { path: 'beauty/:id/:idc', canActivate: [AuthGuard], component: ProductListComponent},
    { path: 'HighTec/:id/all', canActivate: [AuthGuard], component: ProductListComponent},
    { path: 'HighTec/:id/:idc', canActivate: [AuthGuard],  component: ProductListComponent},
    { path: 'jewelry/:id/all', canActivate: [AuthGuard], component: ProductListComponent},
    { path: 'jewelry/:id/:idc', canActivate: [AuthGuard],  component: ProductListComponent},
    /*product Details*/
    { path: ':id/:idc/:idp', canActivate: [AuthGuard], component: ProductDetailsComponent},
    /*not found*/
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
    HighTecComponent,
    ProductDetailsComponent,
    BasketListComponent,
    SignupComponent,
    SigninComponent,
    ContainerComponent,
    CustomerProfileComponent,
    JewelryComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule.forRoot(appRoutes),
  ],
  providers: [
      BrandService,
      ShopingService,
      CustomerService,
      AuthGuard,
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
