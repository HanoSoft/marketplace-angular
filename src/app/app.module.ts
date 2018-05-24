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
import { AdressComponent } from './adress/adress.component';
import {AddressService} from './services/address.service';
import { PaymentComponent } from './payment/payment.component';
import { ConfirmationComponent } from './confirmation/confirmation.component';
import { LoadingComponent } from './loading/loading.component';
import { ModalModule } from 'ngx-bootstrap/modal';
import { OrdersComponent } from './orders/orders.component';
import { OrderItemsComponent } from './order-items/order-items.component';
import { SearchComponent } from './search/search.component';


const appRoutes: Routes = [
    { path: 'auth', component: SigninComponent},
    { path: 'signup', component: SignupComponent},
    { path: 'profile', canActivate: [AuthGuard], component: CustomerProfileComponent },
    { path: '', component: HomeComponent},
    /*basket-list*/
    { path: 'basket', component: BasketListComponent},
    { path: 'address', canActivate: [AuthGuard], component: AdressComponent},
    { path: 'payment', canActivate: [AuthGuard], component: PaymentComponent},
    { path: 'confirmation', canActivate: [AuthGuard], component: ConfirmationComponent},
    { path: 'orders', canActivate: [AuthGuard], component: OrdersComponent},
    { path: 'clothes',  component: ClothesComponent},
    { path: 'beauty',  component: BeautyComponent},
    { path: 'HighTec',  component: HighTecComponent},
    { path: 'jewelry',  component: JewelryComponent},
    { path: 'search',  component: SearchComponent},
    /*single brand*/
    { path: ':id',  component: SingleBrandComponent},
    { path: 'clothes/:id', component: SingleBrandComponent},
    { path: 'beauty/:id',  component: SingleBrandComponent},
    { path: 'HighTec/:id',  component: SingleBrandComponent},
    { path: 'jewelry/:id',  component: SingleBrandComponent},
    { path: 'search/:idp',  component: ProductDetailsComponent},
    /*product list */
    { path: ':id/all', component: ProductListComponent},
    { path: ':id/:idc',  component: ProductListComponent},
    { path: 'clothes/:id/all',  component: ProductListComponent},
    { path: 'clothes/:id/:idc',  component: ProductListComponent},
    { path: 'beauty/:id/all',  component: ProductListComponent},
    { path: 'beauty/:id/:idc',  component: ProductListComponent},
    { path: 'HighTec/:id/all',  component: ProductListComponent},
    { path: 'HighTec/:id/:idc',   component: ProductListComponent},
    { path: 'jewelry/:id/all', component: ProductListComponent},
    { path: 'jewelry/:id/:idc',   component: ProductListComponent},
    /*product Details*/
    { path: ':id/:idc/:idp',  component: ProductDetailsComponent},
    { path: 'clothes/:id/:idc/:idp',  component: ProductDetailsComponent},
    { path: 'beauty/:id/:idc/:idp',  component: ProductDetailsComponent},
    { path: 'HighTec/:id/:idc/:idp',  component: ProductDetailsComponent},
    { path: 'jewelry/:id/:idc/:idp',  component: ProductDetailsComponent},

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
    AdressComponent,
    PaymentComponent,
    ConfirmationComponent,
    LoadingComponent,
    OrdersComponent,
    OrderItemsComponent,
    SearchComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule.forRoot(appRoutes),
    ModalModule.forRoot(),
  ],
  providers: [
      BrandService,
      ShopingService,
      CustomerService,
      AuthGuard,
      AddressService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
