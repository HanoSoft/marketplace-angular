import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';


import { AppComponent } from './app.component';
import { HeaderComponent } from './header/header.component';
import { TopNavComponent } from './top-nav/top-nav.component';
import { MidleNavComponent } from './midle-nav/midle-nav.component';
import { NavbarComponent } from './navbar/navbar.component';
import {RouterModule, Routes} from '@angular/router';
import { HomeComponent } from './home/home.component';
import {HttpClientModule} from '@angular/common/http';
import {BrandService} from './services/brand.service';
import { BrandListComponent } from './brand-list/brand-list.component';

const appRoutes: Routes = [
    { path: 'home', component: HomeComponent}
];

@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    TopNavComponent,
    MidleNavComponent,
    NavbarComponent,
    HomeComponent,
    BrandListComponent,
  ],
  imports: [
    BrowserModule,
      HttpClientModule,
      RouterModule.forRoot(appRoutes)
  ],
  providers: [
      BrandService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
