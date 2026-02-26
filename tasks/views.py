from django.shortcuts import render, redirect
from django.contrib.auth import login
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from django.urls import reverse_lazy
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.mixins import LoginRequiredMixin
from .models import Task


# ---------- AUTH ----------

def register(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('task_list')
    else:
        form = UserCreationForm()
    return render(request, 'tasks/register.html', {'form': form})


# ---------- TASK LIST ----------

class TaskListView(LoginRequiredMixin, ListView):
    model = Task
    template_name = 'tasks/task_list.html'
    context_object_name = 'tasks'
    login_url = '/login/'

    def get_queryset(self):
        return Task.objects.filter(user=self.request.user)


# ---------- CREATE ----------

class TaskCreateView(LoginRequiredMixin, CreateView):
    model = Task
    fields = ['title', 'description', 'completed']
    template_name = 'tasks/task_form.html'
    success_url = reverse_lazy('task_list')
    login_url = '/login/'

    def form_valid(self, form):
        form.instance.user = self.request.user
        return super().form_valid(form)


# ---------- UPDATE ----------

class TaskUpdateView(LoginRequiredMixin, UpdateView):
    model = Task
    fields = ['title', 'description', 'completed']
    template_name = 'tasks/task_form.html'
    success_url = reverse_lazy('task_list')
    login_url = '/login/'


# ---------- DELETE ----------

class TaskDeleteView(LoginRequiredMixin, DeleteView):
    model = Task
    template_name = 'tasks/task_confirm_delete.html'
    success_url = reverse_lazy('task_list')
    login_url = '/login/'
