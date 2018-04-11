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
import { AuthComponent } from './auth/auth.component';
import { AuthNavComponent } from './auth-nav/auth-nav.component';
import { BrandListComponent } from './brand-list/brand-list.component';
import { BrandComponent } from './brand/brand.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import { FooterComponent } from './footer/footer.component';


const appRoutes: Routes = [
    { path: 'home', component: HomeComponent},
    { path: 'auth', component: AuthComponent}
];

@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    TopNavComponent,
    MidleNavComponent,
    NavbarComponent,
    HomeComponent,
    AuthComponent,
    AuthNavComponent,
    BrandListComponent,
    BrandComponent,
    FooterComponent,
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
