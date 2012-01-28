;;; winpath.el --- ???

;; Copyright (C) 2011  U-TreeFrog\lieutar

;; Author: U-TreeFrog\lieutar <lieutar@TreeFrog>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:


(defconst winpath:file-name-regexp
  "^\\(.*?/\\)?\\([a-zA-Z]\\):\\([/\\\\].*\\)" )

(defun winpath:cygwin-name (path)
  (if (string-match winpath:file-name-regexp path)
      (format "/cygdrive/%s%s" 
              (match-string 2 path)
              (replace-regexp-in-string
               "\\\\" "/"
               (match-string 3 path)))
    path))

(defun winpath:file-name-handler (operation &rest args)
  (let ((inhibit-file-name-handlers
         (append '(winpath:file-name-handler)
                 inhibit-file-name-handlers))
        (inhibit-file-name-operation operation))
    (apply operation
           (if (or (eq operation 'substitute-in-file-name)
                   (eq operation 'expand-file-name))

               (let ((name (car args))
                     (args (cdr args)))
                 (cons (winpath:cygwin-name name)
                       (if (and args (car args))
                           (cons  (winpath:cygwin-name (car args))
                                  (copy-sequence (cdr args)))
                         args)))
             args))))

(add-to-list 'file-name-handler-alist
             `(,winpath:file-name-regexp . winpath:file-name-handler))
;;(string-match winpath:file-name-regexp "c:/cygwin")
;;file-name-handler-alist

(provide 'winpath)
;;; winpath.el ends here
