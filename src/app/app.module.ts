import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';


import { AppComponent } from './app.component';
import { HeaderComponent } from './header/header.component';
import { TopNavComponent } from './top-nav/top-nav.component';
import {RouterModule, Routes} from '@angular/router';
import { HomeComponent } from './home/home.component';
import {HttpClientModule} from '@angular/common/http';
import {BrandService} from './services/brand.service';
import { BrandListComponent } from './brand-list/brand-list.component';
import { BrandComponent } from './brand/brand.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import { SingleBrandComponent } from './single-brand/single-brand.component';
import { HorizontalTabComponent } from './horizontal-tab/horizontal-tab.component';
import { NotFoundComponent } from './not-found/not-found.component';
import { ProductListComponent } from './product-list/product-list.component';



const appRoutes: Routes = [
    { path: '', component: HomeComponent},
    { path: ':id', component: SingleBrandComponent},
    {path: 'not-found', component: NotFoundComponent},
    {path: '**', redirectTo: '/not-found'},
];

@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    TopNavComponent,
    HomeComponent,
    BrandListComponent,
    BrandComponent,
    SingleBrandComponent,
    HorizontalTabComponent,
    NotFoundComponent,
    ProductListComponent,
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
