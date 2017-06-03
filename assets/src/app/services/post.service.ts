import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';

import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';

@Injectable()
export class PostService {

  constructor(private http: Http) {}

  fetchAll(): Observable<Post[]> {
    return this.http.get("/api/posts").map((res: Response) => {
      return res.json().posts.map(post => new Post(post.body));
    });
  }

  create(body: string): Observable<Post> {
    return this.http.post("/api/posts", {body: body}).map((res: Response) => {
      return new Post(res.json().post.body);
    });
  }
}

export class Post {
  constructor(public body: string) {}
}
