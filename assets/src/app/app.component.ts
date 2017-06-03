import { Component, OnInit } from '@angular/core';

import { PostService, Post } from './services/post.service';

@Component({
  selector: 'nyon-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  private posts: Post[];
  private body: string;

  constructor(private postService: PostService) {}

  ngOnInit() {
    this.fetchPosts();
  }

  fetchPosts(): void {
    this.postService.fetchAll().subscribe((posts: Post[]) => {
      this.posts = posts;
    });
  }

  createPost(): void {
    this.postService.create(this.body).subscribe((post: Post) => {
      this.body = "";
      this.posts.unshift(post);
    });
  }
}
