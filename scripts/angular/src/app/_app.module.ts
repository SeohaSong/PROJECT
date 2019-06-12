import { BrowserModule } from '@angular/platform-browser';

@NgModule({
  imports: [
    BrowserModule.withServerTransition({appId: 'client'}),
    AppRoutingModule,
    FormsModule
  ]
})