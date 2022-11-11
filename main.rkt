#lang racket
(provide (all-defined-out))

(define := (lambda (var value) (list var value)))

(define -- (lambda args (cons 'let (list args))))

(define @ (lambda (bindings expr) (list (car bindings) (cadr bindings) (car expr))))

(define (split_at_delim delim args) (foldr (lambda (curr res) (if (equal? curr delim) (cons '() res) (cons (cons curr (car res)) (cdr res)) )) (list empty) args))

(define (change_operator_operand lst)
  (if
   (and (list? lst) (not (equal? lst '())) (> (length lst) 2))
     (let ((operand1 (car lst))
           (operator (cadr lst))
           (operand2 (cddr lst)))
       (list operator
             (change_operator_operand operand1) (change_operator_operand operand2)))
      (if (and (not (equal? lst '())) (list? lst)) (change_operator_operand (car lst)) lst)
    )
  )

(define (split_to_plus lst) (if (and (list? lst) (member '+ lst))
                             (append '(+) (map (lambda curr  (parse_expr curr)) (split_at_delim '+  lst)))
                             (split_to_mult lst)))

(define (split_to_mult lst) (if (and (list? lst) (member '* lst))
                             (append '(*) (map (lambda curr (parse_expr curr)) (split_at_delim '*  lst)))
                             (split_to_bind lst)))

(define (merge_lists lst first) (foldr (lambda (curr res) (append (list curr) res)) (list first) lst ))

(define (split_to_bind lst) (if (and (list? lst) (member '@ lst))
                                (merge_lists ( all_bindings (remove_parant (car (split_at_delim '@ lst)))) (parse_expr (caadr (split_at_delim '@ lst))))
                                             (change_operator_operand lst)))

(define (all_bindings lst) (apply -- (merge_bindings (split_at_delim '-- lst))))

(define (merge_bindings lst) (foldl (lambda (curr res) (if (not (equal? curr '())) (append res (list (parse_assignment curr))) res)) '() lst))

(define (parse_assignment lst) (:= (var_num (car lst)) (var_num (caddr lst))))

(define (var_num lst) (if (number?  lst)  lst (cadr lst)))

(define (parse_expr lst) (split_to_plus (remove_parant lst)))

(define (remove_parant lst) (if (and (list?  lst) (equal? (length lst) 1) (list?  (car lst)) ) (remove_parant (car lst)) lst))

(define eval_expr (lambda (expr) (eval (parse_expr expr))))