"use client"

import { useState, useEffect, useRef } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Card } from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import { Badge } from "@/components/ui/badge"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Trash2, Plus, Search, Flag, Tag, CheckCheck, Star, Archive, Edit3, Sparkles } from "lucide-react"

interface Todo {
  id: number
  text: string
  completed: boolean
  createdAt: Date
  dueDate?: Date
  priority: "low" | "medium" | "high"
  category: string
  starred: boolean
}

const CATEGORIES = ["Personal", "Work", "Shopping", "Health", "Learning"]
const PRIORITY_COLORS = {
  low: "bg-blue-100 text-blue-800 border-blue-200",
  medium: "bg-yellow-100 text-yellow-800 border-yellow-200",
  high: "bg-red-100 text-red-800 border-red-200",
}

export default function TodoApp() {
  const [todos, setTodos] = useState<Todo[]>([])
  const [newTodo, setNewTodo] = useState("")
  const [searchTerm, setSearchTerm] = useState("")
  const [filter, setFilter] = useState<"all" | "active" | "completed" | "starred">("all")
  const [selectedCategory, setSelectedCategory] = useState<string>("all")
  const [selectedTodos, setSelectedTodos] = useState<Set<number>>(new Set())
  const [isEditing, setIsEditing] = useState<number | null>(null)
  const [editText, setEditText] = useState("")
  const [showQuickAdd, setShowQuickAdd] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    const saved = localStorage.getItem("intuitive-todos")
    if (saved) {
      const parsed = JSON.parse(saved)
      setTodos(
        parsed.map((todo: any) => ({
          ...todo,
          createdAt: new Date(todo.createdAt),
          dueDate: todo.dueDate ? new Date(todo.dueDate) : undefined,
        })),
      )
    }
  }, [])

  useEffect(() => {
    if (todos.length > 0) {
      localStorage.setItem("intuitive-todos", JSON.stringify(todos))
    }
  }, [todos])

  useEffect(() => {
    if (showQuickAdd && inputRef.current) {
      inputRef.current.focus()
    }
  }, [showQuickAdd])

  const addTodo = (category = "Personal", priority: "low" | "medium" | "high" = "medium") => {
    if (newTodo.trim()) {
      setTodos([
        {
          id: Date.now(),
          text: newTodo.trim(),
          completed: false,
          createdAt: new Date(),
          priority,
          category,
          starred: false,
        },
        ...todos,
      ])
      setNewTodo("")
      setShowQuickAdd(false)
    }
  }

  const addQuickTodo = (text: string, category?: string, priority?: "low" | "medium" | "high") => {
    const todo = {
      id: Date.now(),
      text,
      completed: false,
      createdAt: new Date(),
      priority: priority || "medium",
      category: category || "Personal",
      starred: false,
    }
    setTodos([todo, ...todos])
  }

  const toggleTodo = (id: number) => {
    setTodos(todos.map((todo) => (todo.id === id ? { ...todo, completed: !todo.completed } : todo)))
  }

  const deleteTodo = (id: number) => {
    setTodos(todos.filter((todo) => todo.id !== id))
    setSelectedTodos((prev) => {
      const newSet = new Set(prev)
      newSet.delete(id)
      return newSet
    })
  }

  const toggleStar = (id: number) => {
    setTodos(todos.map((todo) => (todo.id === id ? { ...todo, starred: !todo.starred } : todo)))
  }

  const startEdit = (id: number, text: string) => {
    setIsEditing(id)
    setEditText(text)
  }

  const saveEdit = () => {
    if (isEditing && editText.trim()) {
      setTodos(todos.map((todo) => (todo.id === isEditing ? { ...todo, text: editText.trim() } : todo)))
    }
    setIsEditing(null)
    setEditText("")
  }

  const toggleSelection = (id: number) => {
    setSelectedTodos((prev) => {
      const newSet = new Set(prev)
      if (newSet.has(id)) {
        newSet.delete(id)
      } else {
        newSet.add(id)
      }
      return newSet
    })
  }

  const bulkComplete = () => {
    setTodos(todos.map((todo) => (selectedTodos.has(todo.id) ? { ...todo, completed: true } : todo)))
    setSelectedTodos(new Set())
  }

  const bulkDelete = () => {
    setTodos(todos.filter((todo) => !selectedTodos.has(todo.id)))
    setSelectedTodos(new Set())
  }

  const clearCompleted = () => {
    setTodos(todos.filter((todo) => !todo.completed))
  }

  const filteredTodos = todos.filter((todo) => {
    const matchesSearch = todo.text.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesFilter =
      filter === "all" ||
      (filter === "active" && !todo.completed) ||
      (filter === "completed" && todo.completed) ||
      (filter === "starred" && todo.starred)
    const matchesCategory = selectedCategory === "all" || todo.category === selectedCategory
    return matchesSearch && matchesFilter && matchesCategory
  })

  const completedCount = todos.filter((todo) => todo.completed).length
  const totalCount = todos.length
  const starredCount = todos.filter((todo) => todo.starred).length

  const quickSuggestions = [
    { text: "Buy groceries", category: "Shopping", priority: "medium" as const },
    { text: "Exercise for 30 minutes", category: "Health", priority: "high" as const },
    { text: "Check emails", category: "Work", priority: "low" as const },
    { text: "Read for 20 minutes", category: "Learning", priority: "low" as const },
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-4 max-w-4xl mx-auto">
      {/* Header */}
      <div className="mb-8 text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-2 flex items-center justify-center gap-2">
          <Sparkles className="w-8 h-8 text-indigo-600" />
          My Tasks
        </h1>
        <div className="flex justify-center gap-6 text-sm text-gray-600">
          <span>
            {completedCount} of {totalCount} completed
          </span>
          <span>{starredCount} starred</span>
          <span>{todos.filter((t) => !t.completed).length} remaining</span>
        </div>
      </div>

      {/* Quick Add Suggestions */}
      {todos.length === 0 && (
        <Card className="p-6 mb-6 bg-white/80 backdrop-blur border-indigo-200">
          <h3 className="text-lg font-semibold text-gray-900 mb-3 flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-indigo-600" />
            Quick Start
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
            {quickSuggestions.map((suggestion, index) => (
              <Button
                key={index}
                variant="outline"
                className="justify-start text-left h-auto p-3 hover:bg-indigo-50 border-indigo-200 bg-transparent"
                onClick={() => addQuickTodo(suggestion.text, suggestion.category, suggestion.priority)}
              >
                <div>
                  <div className="font-medium">{suggestion.text}</div>
                  <div className="text-xs text-gray-500">
                    {suggestion.category} • {suggestion.priority} priority
                  </div>
                </div>
              </Button>
            ))}
          </div>
        </Card>
      )}

      {/* Add Task Section */}
      <Card className="p-4 mb-6 bg-white/80 backdrop-blur border-indigo-200">
        <div className="space-y-3">
          <div className="flex gap-2">
            <Input
              ref={inputRef}
              placeholder="What needs to be done?"
              value={newTodo}
              onChange={(e) => setNewTodo(e.target.value)}
              onKeyPress={(e) => e.key === "Enter" && addTodo()}
              className="flex-1 border-indigo-200 focus:ring-indigo-500"
            />
            <Button
              onClick={() => addTodo()}
              className="bg-indigo-600 hover:bg-indigo-700 text-white"
              disabled={!newTodo.trim()}
            >
              <Plus className="w-4 h-4" />
            </Button>
          </div>

          {newTodo.trim() && (
            <div className="flex gap-2 text-sm">
              <Select defaultValue="Personal">
                <SelectTrigger className="w-32">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {CATEGORIES.map((cat) => (
                    <SelectItem key={cat} value={cat}>
                      {cat}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>

              <Select defaultValue="medium">
                <SelectTrigger className="w-32">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="low">Low Priority</SelectItem>
                  <SelectItem value="medium">Medium Priority</SelectItem>
                  <SelectItem value="high">High Priority</SelectItem>
                </SelectContent>
              </Select>
            </div>
          )}
        </div>
      </Card>

      {/* Search, Filter and Bulk Actions */}
      <div className="space-y-3 mb-6">
        <div className="flex gap-2">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
            <Input
              placeholder="Search tasks..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 border-indigo-200 focus:ring-indigo-500"
            />
          </div>

          <Select value={selectedCategory} onValueChange={setSelectedCategory}>
            <SelectTrigger className="w-40">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All Categories</SelectItem>
              {CATEGORIES.map((cat) => (
                <SelectItem key={cat} value={cat}>
                  {cat}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="flex justify-between items-center">
          <div className="flex gap-1">
            {(["all", "active", "completed", "starred"] as const).map((filterType) => (
              <Button
                key={filterType}
                variant={filter === filterType ? "default" : "outline"}
                size="sm"
                onClick={() => setFilter(filterType)}
                className={filter === filterType ? "bg-indigo-600 text-white" : "border-indigo-200"}
              >
                {filterType === "starred" && <Star className="w-3 h-3 mr-1" />}
                {filterType.charAt(0).toUpperCase() + filterType.slice(1)}
              </Button>
            ))}
          </div>

          {selectedTodos.size > 0 && (
            <div className="flex gap-2">
              <Button size="sm" variant="outline" onClick={bulkComplete}>
                <CheckCheck className="w-3 h-3 mr-1" />
                Complete ({selectedTodos.size})
              </Button>
              <Button size="sm" variant="outline" onClick={bulkDelete} className="text-red-600 bg-transparent">
                <Trash2 className="w-3 h-3 mr-1" />
                Delete ({selectedTodos.size})
              </Button>
            </div>
          )}

          {completedCount > 0 && (
            <Button size="sm" variant="outline" onClick={clearCompleted} className="text-gray-600 bg-transparent">
              <Archive className="w-3 h-3 mr-1" />
              Clear Completed
            </Button>
          )}
        </div>
      </div>

      {/* Tasks List */}
      <div className="space-y-3">
        {filteredTodos.length === 0 ? (
          <Card className="p-8 text-center bg-white/80 backdrop-blur border-indigo-200">
            <div className="text-gray-400 mb-2">
              {searchTerm || filter !== "all" || selectedCategory !== "all" ? (
                <Search className="w-12 h-12 mx-auto mb-3" />
              ) : (
                <CheckCheck className="w-12 h-12 mx-auto mb-3" />
              )}
            </div>
            <p className="text-gray-600">
              {searchTerm || filter !== "all" || selectedCategory !== "all"
                ? "No tasks match your criteria"
                : "All done! Time to add some new tasks."}
            </p>
          </Card>
        ) : (
          filteredTodos.map((todo) => (
            <Card
              key={todo.id}
              className={`p-4 bg-white/80 backdrop-blur border-indigo-200 transition-all duration-200 hover:shadow-md hover:bg-white/90 ${
                todo.completed ? "opacity-75" : ""
              } ${selectedTodos.has(todo.id) ? "ring-2 ring-indigo-500" : ""}`}
            >
              <div className="flex items-center gap-3">
                <Checkbox
                  checked={selectedTodos.has(todo.id)}
                  onCheckedChange={() => toggleSelection(todo.id)}
                  className="data-[state=checked]:bg-indigo-600 data-[state=checked]:border-indigo-600"
                />

                <Checkbox
                  checked={todo.completed}
                  onCheckedChange={() => toggleTodo(todo.id)}
                  className="data-[state=checked]:bg-green-600 data-[state=checked]:border-green-600"
                />

                <div className="flex-1 min-w-0">
                  {isEditing === todo.id ? (
                    <div className="flex gap-2">
                      <Input
                        value={editText}
                        onChange={(e) => setEditText(e.target.value)}
                        onKeyPress={(e) => e.key === "Enter" && saveEdit()}
                        onBlur={saveEdit}
                        className="flex-1"
                        autoFocus
                      />
                    </div>
                  ) : (
                    <div>
                      <span
                        className={`block font-medium ${
                          todo.completed ? "line-through text-gray-500" : "text-gray-900"
                        }`}
                      >
                        {todo.text}
                      </span>
                      <div className="flex items-center gap-2 mt-1">
                        <Badge variant="outline" className={PRIORITY_COLORS[todo.priority]}>
                          <Flag className="w-3 h-3 mr-1" />
                          {todo.priority}
                        </Badge>
                        <Badge variant="outline" className="bg-gray-100 text-gray-700">
                          <Tag className="w-3 h-3 mr-1" />
                          {todo.category}
                        </Badge>
                        <span className="text-xs text-gray-500">{todo.createdAt.toLocaleDateString()}</span>
                      </div>
                    </div>
                  )}
                </div>

                <div className="flex items-center gap-1">
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => toggleStar(todo.id)}
                    className={
                      todo.starred ? "text-yellow-500 hover:text-yellow-600" : "text-gray-400 hover:text-yellow-500"
                    }
                  >
                    <Star className={`w-4 h-4 ${todo.starred ? "fill-current" : ""}`} />
                  </Button>

                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => startEdit(todo.id, todo.text)}
                    className="text-gray-400 hover:text-gray-600"
                  >
                    <Edit3 className="w-4 h-4" />
                  </Button>

                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => deleteTodo(todo.id)}
                    className="text-gray-400 hover:text-red-600"
                  >
                    <Trash2 className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            </Card>
          ))
        )}
      </div>

      {/* Progress Bar */}
      {totalCount > 0 && (
        <Card className="mt-6 p-4 bg-white/80 backdrop-blur border-indigo-200">
          <div className="flex justify-between items-center mb-2">
            <span className="text-sm font-medium text-gray-900">Overall Progress</span>
            <span className="text-sm text-gray-600">{Math.round((completedCount / totalCount) * 100)}%</span>
          </div>
          <div className="w-full bg-gray-200 rounded-full h-3">
            <div
              className="bg-gradient-to-r from-indigo-500 to-purple-600 h-3 rounded-full transition-all duration-500 ease-out"
              style={{ width: `${(completedCount / totalCount) * 100}%` }}
            />
          </div>
          <div className="flex justify-between text-xs text-gray-500 mt-1">
            <span>{completedCount} completed</span>
            <span>{totalCount - completedCount} remaining</span>
          </div>
        </Card>
      )}
    </div>
  )
}
