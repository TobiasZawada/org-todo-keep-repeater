(defun org-todo-keep-repeater (todo)
  "Call `org-todo' with TODO keyword but keep repeater."
  (interactive (list (completing-read "Set todo state of current headline to:" org-todo-keywords-1)))
  (let ((my-marker-b (make-marker))
	(my-marker-e (make-marker))
	my-original-repeater)
    (cl-letf* ((old-replace-match (symbol-function 'replace-match))
	       ((symbol-function 'replace-match)
		(lambda (&rest args)
		  (setq my-original-repeater (match-string 0))
		  (set-marker my-marker-b (match-beginning 0))
		  (set-marker my-marker-e (match-end 0))
		  (apply old-replace-match args))))
      (org-cancel-repeater))
    (if my-original-repeater
	(progn
	  (org-todo todo)
	  (save-excursion
	    (goto-char my-marker-b)
	    (delete-region my-marker-b my-marker-e)
	    (insert my-original-repeater))
	  (set-marker my-marker-b nil)
	  (set-marker my-marker-e nil))
      (org-todo todo))))
