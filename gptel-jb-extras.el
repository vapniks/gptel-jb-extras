;;; gptel-jb-extras.el --- Extra functions and commands for gptel.el

;; Filename: gptel-jb-extras.el
;; Description: Extra functions and commands for gptel.el
;; Author: Joe Bloggs <vapniks@yahoo.com>
;; Maintainer: Joe Bloggs <vapniks@yahoo.com>
;; Copyleft (Ↄ) 2026, Joe Bloggs, all rites reversed.
;; Created: 2026-03-18 01:56:24
;; Version: 20260322.56
;; Last-Updated: Sun Mar 22 00:56:33 2026
;;           By: Joe Bloggs
;;     Update #: 3
;; URL: https://github.com/vapniks/gptel-jb-extras
;; Keywords: convenience
;; Compatibility: GNU Emacs 30.1
;; Package-Requires: ((gptel "20260316.552"))
;;
;; Features that might be required by this library:
;;
;; 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.
;; If not, see <http://www.gnu.org/licenses/>.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Commentary: 
;; 
;; Bitcoin donations gratefully accepted: 1ArFina3Mi8UDghjarGqATeBgXRDWrsmzo
;; 
;;; Installation
;; To install:
;; 
;;  - Put the library in a directory in the emacs load path, like ~/.emacs.d/
;;  - Add (require 'gptel-jb-extras) in your ~/.emacs file
;;;;;;;;

;;; Commands:
;;
;; Below is a complete list of commands:
;;
;;  `gptel-set-log-level'
;;    Prompt the user to set the VALUE of `gptel-log-level'.
;;    Keybinding: M-x gptel-set-log-level
;;  `gptel-display-log'
;;    Display the *gptel-log* buffer.
;;    Keybinding: M-x gptel-display-log
;;  `gptel-display-or-set-log'
;;    Display the *gptel-log* buffer or set the value of `gptel-log-level'.
;;    Keybinding: M-x gptel-display-or-set-log
;;  `gptel-show-outline'
;;    Show an outline of prompts and org-headings in the current chat buffer.
;;    Keybinding: M-x gptel-show-outline
;;  `gptel-insert-prompt-prefix-string'
;;    Insert the prompt prefix at the start of the line.
;;    Keybinding: M-x gptel-insert-prompt-prefix-string
;;  `gptel-insert-response-prefix-string'
;;    Insert the response prefix at the start of the line.
;;    Keybinding: M-x gptel-insert-response-prefix-string
;;  `gptel-add-prompt-labels'
;;    Insert labels at the start of lines following each prompt.
;;    Keybinding: M-x gptel-add-prompt-labels
;;  `gptel-remove-prompt-labels'
;;    Remove prompt labels in the current gptel buffer that match `gptel-label-format'.
;;    Keybinding: M-x gptel-remove-prompt-labels
;;  `gptel-refactor-buffer'
;;    Rearrange Q&A pairs in the current gptel buffer per ORDER.
;;    Keybinding: M-x gptel-refactor-buffer
;;  `gptel-recalculate-bounds'
;;    Recalculate gptel response boundaries from prefix strings.
;;    Keybinding: M-x gptel-recalculate-bounds
;;  `fastgpt-query'
;;    Query Kagi FastGPT with QUERY and display the response in *FastGPT* buffer.
;;    Keybinding: C-M-S-s-f
;;
;;; Customizable Options:
;;
;; Below is a list of customizable options:
;;
;;  `gptel-label-format'
;;    Format string for labels used by `gptel-add-prompt-labels'.
;;    default = "Q%d) "

;;
;; All of the above can be customized by:
;;      M-x customize-group RET gptel-jb-extras RET
;;

;;; Installation:
;;
;; Put gptel-jb-extras.el in a directory in your load-path, e.g. ~/.emacs.d/
;; You can add a directory to your load-path with the following line in ~/.emacs
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;; where ~/elisp is the directory you want to add 
;; (you don't need to do this for ~/.emacs.d - it's added by default).
;;
;; Add the following to your ~/.emacs startup file.
;;
;; (require 'gptel-jb-extras)

;;; History:

;;; Require


;;; Code:

;; REMEMBER TODO ;;;###autoload's 

;;;###autoload
(defun gptel-set-log-level (value)
  "Prompt the user to set the VALUE of `gptel-log-level'."
  (interactive (list (ido-completing-read "Set logging level: "
					  '("No logging" "Limited" "Full"))))
  (cond ((equal value "No logging")
	 (setq gptel-log-level nil))
	((equal value "Limited")
	 (setq gptel-log-level 'info))
	((equal value "Full")
	 (setq gptel-log-level 'debug))))
;;;###autoload
(defun gptel-display-log nil
  "Display the *gptel-log* buffer."
  (interactive)
  (if (get-buffer "*gptel-log*")
      (display-buffer "*gptel-log*")
    (message "No *gptel-log* buffer found")))
;;;###autoload
(defun gptel-display-or-set-log (arg)
  "Display the *gptel-log* buffer or set the value of `gptel-log-level'.
If called with a prefix arg then prompt the user to set the value of `gptel-log-level',
otherwise display the *gptel-log* buffer."
  (interactive "P")
  (if arg
      (call-interactively 'gptel-set-log-level)
    (call-interactively 'gptel-display-log)))
;;;###autoload
(defun gptel-show-outline nil
  "Show an outline of prompts and org-headings in the current chat buffer."
  (interactive)
  (occur (concat "^\\(\\*+ .*\\|" (gptel-prompt-prefix-string) "\\)"))
  (other-window 1))
;;;###autoload
(defun gptel-insert-prompt-prefix-string nil
  "Insert the prompt prefix at the start of the line."
  (interactive)
  (beginning-of-line nil)
  (insert (gptel-prompt-prefix-string)))
;;;###autoload
(defun gptel-insert-response-prefix-string nil
  "Insert the response prefix at the start of the line."
  (interactive)
  (beginning-of-line nil)
  (insert (gptel-response-prefix-string)))
;;;###autoload
(defcustom gptel-label-format "Q%d) "
  "Format string for labels used by `gptel-add-prompt-labels'.
The labels are created by (format gptel-label-format counter), where counter counts
the user prompts from the start of the buffer, so it should contain a single %d.")
;;;###autoload
(defun gptel-add-prompt-labels (&optional query start)
  "Insert labels at the start of lines following each prompt.
By default labels are created using `gptel-label-format' (which see).
When QUERY is non-nil, prompt the user at each replacement.
START is the starting number for the prompt counter (defaults to 1).
When called interactively with a prefix argument `gptel-remove-prompt-labels' will
be called instead."
  (interactive
   (when (memq 'gptel-mode local-minor-modes)
     (list (y-or-n-p "Query each replacement? ")
           (read-number "Start from: " 1))))
  (if (and current-prefix-arg
	   (called-interactively-p 'interactive))
      (call-interactively 'gptel-remove-prompt-labels)
    (if (not (memq 'gptel-mode local-minor-modes))
	(message "This is not a gptel-mode buffer.")
      (goto-char (point-min))
      (let ((counter (or start 1))
            (pattern (regexp-quote (gptel-prompt-prefix-string))))
	(while (re-search-forward pattern nil t)
	  (let* ((match (match-string 0))
		 (replacement (concat match (format gptel-label-format counter))))
            (if query
		(pcase (read-char-choice
			(format "Replace with %d? (y/n/e/!/q) " counter)
			'(?y ?n ?e ?! ?q))
		  (?y (replace-match replacement t t)
		      (setq counter (1+ counter)))
		  (?n nil)
		  (?e (let ((custom (read-string "Insert string: ")))
			(replace-match (concat match custom ") ") t t)
			(setq counter (1+ counter))))
		  (?! (replace-match replacement t t)
		      (setq counter (1+ counter) query nil))
		  (?q (goto-char (point-max))))
	      (replace-match replacement t t)
	      (setq counter (1+ counter)))))))))
;;;###autoload
(defun gptel-remove-prompt-labels (&optional query format)
  "Remove prompt labels in the current gptel buffer that match `gptel-label-format'.
If QUERY is non-nil prompt the user before removing each label."
  (interactive (when (memq 'gptel-mode local-minor-modes)
		 (list (y-or-n-p "Query each deletion? ")
		       (read-string (format "Format (default = \"%s\") " gptel-label-format)
				    nil nil gptel-label-format))))
  (if (not (memq 'gptel-mode local-minor-modes))
      (message "This is not a gptel-mode buffer.")
    (goto-char (point-min))
    (let* ((promptprefix (regexp-quote (gptel-prompt-prefix-string)))
	   (pattern (concat promptprefix
			    "\\(" (replace-regexp-in-string
				   "%d" "[0-9]+"
				   (regexp-quote (or format gptel-label-format)))
			    "\\)")))
      (while (re-search-forward pattern nil t)
	(let ((match (match-string 1)))
          (if query
	      (pcase (read-char-choice
		      (format "Remove %s label? (y/n/!/q) " match)
		      '(?y ?n ?e ?! ?q))
		(?y (replace-match promptprefix t t))
		(?n nil)
		(?! (replace-match promptprefix t t)
                    (setq query nil))
		(?q (goto-char (point-max))))
            (replace-match promptprefix t t)))))))
;;;###autoload
(defun gptel-refactor-buffer (order &rest headers)
  "Rearrange Q&A pairs in the current gptel buffer per ORDER.
ORDER is a list of integers indicating the desired sequence of Q&A pairs.
HEADERS is a sequence of lists of cons cells (Q-NUM . TEXT).
The first list specifies depth-1 org-headers (* TEXT), the second
depth-2 (** TEXT), etc.  A Q&A pair may appear in multiple header lists;
headers are written out in depth order before the pair.
Results are displayed in a new buffer with `gptel-mode' enabled and
text properties preserved."
  (interactive
   (list (read--expression "Order (list of integers): ")))
  (let* ((bounds-alist (gptel--get-buffer-bounds))
         (response-bounds (cdr (assq 'response bounds-alist)))
         (pairs (make-hash-table :test 'eql))
         (n (length response-bounds))
         (prompt-prefix (gptel-prompt-prefix-string))
         (first-prompt-beg (save-excursion
                             (goto-char (point-min))
                             (when (search-forward prompt-prefix nil t)
			       (match-beginning 0))))
	 (curbuf (current-buffer))
         (src-mode major-mode)
         (src-settings
          (mapcar (lambda (sym) (cons sym (buffer-local-value sym curbuf)))
                  '(visual-line-mode
                    gptel-backend gptel-model gptel--system-message
                    gptel-temperature gptel-max-tokens gptel-stream
                    gptel-tools gptel--num-messages-to-send)))
         (header-map (make-hash-table :test 'eql))
         (max-depth (length headers)))
    ;; Build header lookup: Q-NUM -> list of strings (positional by depth)
    (when (> max-depth 0)
      (if (eq major-mode 'org-mode)
	  (let ((depth 1))
	    (dolist (header-list headers)
	      (dolist (entry header-list)
		(let ((q-num (car entry)))
		  (unless (gethash q-num header-map)
		    (puthash q-num (make-list max-depth nil) header-map))
		  (setf (nth (1- depth) (gethash q-num header-map)) (cdr entry))))
	      (setq depth (1+ depth))))
	(error "This is not an org-mode buffer!")))
    ;; Extract each Q&A pair with text properties preserved
    (dotimes (i n)
      (let* ((resp-end (cadr (nth i response-bounds)))
             (qa-beg (if (= i 0)
                         (or first-prompt-beg (point-min))
		       (cadr (nth (1- i) response-bounds))))
             (text (string-trim-left (buffer-substring qa-beg resp-end)))
             (q-num (if (string-match
			 (replace-regexp-in-string "%d" "\\\\([0-9]+\\\\)" gptel-label-format)
			 text)
                        (string-to-number (match-string 1 text))
		      (1+ i))))
        (puthash q-num text pairs)))
    ;; Build output buffer
    (let ((buf (get-buffer-create
		(generate-new-buffer-name
		 (concat "*" (replace-regexp-in-string
			      "^\\*\\|\\*$" "" (buffer-name curbuf))
			 "-refactored*")))))
      (with-current-buffer buf
        (let ((inhibit-read-only t))
          (erase-buffer)
          (unless (eq major-mode src-mode)
            (funcall src-mode))
          (dolist (setting src-settings)
            (if (eq (car setting) 'visual-line-mode)
                (visual-line-mode (if (cdr setting) 1 -1))
	      (set (make-local-variable (car setting)) (cdr setting))))
          (dolist (num order)
	    (let ((hs (gethash num header-map))
		  not1st)
	      (when hs
                (let ((depth 1))
                  (dolist (text hs)
		    (when text
		      (unless (or not1st (bobp)) (insert "\n"))
		      (insert (make-string depth ?*) " " text "\n")
		      (setq not1st t))
		    (setq depth (1+ depth))))))
            (let ((pair (gethash num pairs)))
	      (if pair
                  (insert pair)
                (insert (concat "[" (format gptel-label-format num) " not found]\n")))))
          (unless gptel-mode (gptel-mode 1))
          (gptel--save-state)
          (goto-char (point-min))))
      (switch-to-buffer-other-window buf))))
;;;###autoload
(defun gptel-recalculate-bounds ()
  "Recalculate gptel response boundaries from prefix strings.
Scans the buffer for prompt and response prefix strings (from
`gptel-prompt-prefix-string' and `gptel-response-prefix-string'),
clears existing gptel text properties, and reapplies them based
on the prefix positions.
When prompt and response prefixes are identical, they are assumed
to alternate starting with a user prompt.
If in an Org buffer, the properties drawer is updated via
`gptel-org--save-state'.  If `gptel-highlight-mode' is active,
response highlighting is refreshed."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (let* ((prompt-prefix (gptel-prompt-prefix-string))
             (response-prefix (gptel-response-prefix-string))
             (same-prefix-p (string= prompt-prefix response-prefix))
             (prompt-re
              (concat "^" (regexp-quote
                           (string-trim-left prompt-prefix "\n+"))))
             (response-re
              (concat "^" (regexp-quote
                           (string-trim-left response-prefix "\n+"))))
             (combined-re
              (if same-prefix-p prompt-re
                (concat "\\(" response-re "\\)\\|\\(" prompt-re "\\)")))
             (markers nil)
             (new-bounds nil))
        ;; Pass 1: find all prefixes and classify as prompt or response
        (goto-char (point-min))
        (if same-prefix-p
            (let ((is-response nil))
              (while (re-search-forward combined-re nil t)
                (push (list (match-beginning 0) (match-end 0)
                            (if is-response 'response 'prompt))
                      markers)
                (setq is-response (not is-response))))
          (while (re-search-forward combined-re nil t)
            (push (list (match-beginning 0) (match-end 0)
                        (if (match-beginning 1) 'response 'prompt))
                  markers)))
        (setq markers (nreverse markers))
        ;; Pass 2: response region runs from end of response prefix
        ;; to beginning of next prefix (or point-max)
        (let ((rest markers))
          (while rest
            (pcase-let ((`(,_beg ,end ,type) (pop rest)))
              (when (eq type 'response)
                (push (list end (if rest (caar rest) (point-max)))
                      new-bounds)))))
        (setq new-bounds (nreverse new-bounds))
        ;; Clear old properties and apply corrected ones
        (with-silent-modifications
          (remove-text-properties
           (point-min) (point-max)
           '(gptel nil front-sticky nil))
          (dolist (bound new-bounds)
            (add-text-properties
             (car bound) (cadr bound)
             '(gptel response front-sticky (gptel)))))
        ;; Update properties drawer in Org buffers
        (when (derived-mode-p 'org-mode)
          (gptel-org--save-state))
        ;; Refresh highlighting if gptel-highlight-mode is active
        (when (bound-and-true-p gptel-highlight-mode)
          (remove-overlays (point-min) (point-max) 'gptel-highlight t)
          (gptel-highlight--update (point-min) (point-max)))
        (message "Recalculated %d response region(s)."
                 (length new-bounds))))))

;; NOT SURE IF THE FOLLOWING COMMAND IS REALLY NEEDED
;;;###autoload
(defun fastgpt-query (query)
  "Query Kagi FastGPT with QUERY and display the response in *FastGPT* buffer."
  (interactive "sFastGPT query: ")
  (let ((buf (get-buffer-create "*FastGPT*"))
        (backend (alist-get "Kagi" gptel--known-backends nil nil #'equal)))
    (with-current-buffer buf
      (unless (bound-and-true-p gptel-mode)
        (funcall gptel-default-mode)
        (gptel-mode 1))
      (goto-char (point-max))
      (insert (gptel-prompt-prefix-string) query "\n\n"
  	      (gptel-response-prefix-string)))
    (gptel-request query
      :backend backend :model 'fastgpt
      :buffer buf
      :callback (lambda (response info)
  		  (let* ((buf (plist-get info :buffer))
  			 (status (plist-get info :status))
  			 pos)
  		    (display-buffer buf)
                    (with-current-buffer buf
  		      (setq pos (goto-char (point-max)))
  		      (if response
                          (insert response "\n\n")
  			(insert "Error: " status "\n\n"))
  		      (let ((win (get-buffer-window buf)))
  			(when win
                          (set-window-point win pos)
                          (with-selected-window win
  			    (recenter 0)
  			    (let ((needed (+ 1 (count-screen-lines pos (point-max))))
  				  (curlines (window-body-height win))
  				  (maxlines (/ (frame-text-lines) 2)))
  			      (if (< needed maxlines)
  				  (window-resize win (- needed curlines))
  				(window-resize win (- maxlines curlines)))))))))))))

(provide 'gptel-jb-extras)

;; (org-readme-sync)
;; (magit-push)

;;; gptel-jb-extras.el ends here


