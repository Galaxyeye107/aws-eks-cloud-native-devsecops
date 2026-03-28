import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Purchase} from "../common/purchase";
import {Observable} from "rxjs";

@Injectable({
  providedIn: 'root'
})
export class CheckoutService {

  private purchaseUrl = 'http://k8s-default-ecommerc-2b19b0b60c-742252716.ap-southeast-1.elb.amazonaws.com/api/checkout/purchase';
  constructor(private httpClient: HttpClient) {

  }

  placeOrder(purchase: Purchase):Observable<any>{
    return this.httpClient.post<Purchase>(this.purchaseUrl, purchase);
  }
}
