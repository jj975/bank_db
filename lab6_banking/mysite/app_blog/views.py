from django.shortcuts import render
from django.views.generic import TemplateView, ListView, DateDetailView
from .models import Article, Category

# 1. Головна сторінка


class HomePageView(TemplateView):
    def get(self, request, **kwargs):
        context = {
            'categories': Category.objects.all(),
            'articles': Article.objects.filter(main_page=True)[:5]
        }
        return render(request, 'index.html', context)

# 2. Сторінка однієї статті


class ArticleDetail(DateDetailView):
    model = Article
    template_name = 'article_detail.html'
    context_object_name = 'item'
    date_field = 'pub_date'
    query_pk_and_slug = True
    month_format = '%m'
    allow_future = True

    def get_context_data(self, *args, **kwargs):
        context = super(ArticleDetail, self).get_context_data(*args, **kwargs)
        try:
            context['images'] = context['item'].images.all()
        except:
            pass
        return context

# 3. Список статей (Загальний)


class ArticleList(ListView):
    model = Article
    template_name = 'articles_list.html'
    context_object_name = 'items'

    def get_context_data(self, *args, **kwargs):
        context = super(ArticleList, self).get_context_data(*args, **kwargs)
        try:
            context['category'] = Category.objects.get(
                slug=self.kwargs.get('slug'))
        except Exception:
            context['category'] = None
        return context

    def get_queryset(self, *args, **kwargs):
        return Article.objects.all()

# 4. Список статей (За категорією) - саме його не вистачало!


class ArticleCategoryList(ArticleList):
    def get_queryset(self, *args, **kwargs):
        return Article.objects.filter(
            category__slug__in=[self.kwargs['slug']]
        ).distinct()
