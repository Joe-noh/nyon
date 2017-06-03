import { Component, OnInit } from '@angular/core';

import { PostService, Post } from './services/post.service';

@Component({
  selector: 'nyon-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  private posts: Post[];

  constructor(private postService: PostService) {}

  ngOnInit() {
    this.fetchPosts();
  }

  fetchPosts(): void {
    this.postService.fetchAll().subscribe((posts: Post[]) => {
      this.posts = posts;
    });
  }
}
