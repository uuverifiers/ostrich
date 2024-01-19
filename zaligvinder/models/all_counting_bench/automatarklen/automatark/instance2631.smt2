(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Toolbar[^\n\r]*tvshowtickets\w+weatherHost\x3AUser-Agent\x3Atwfofrfzlugq\u{2f}eve\.qd
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "tvshowtickets") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "weatherHost:User-Agent:twfofrfzlugq/eve.qd\u{0a}"))))
; http[s]?://(www|[a-zA-Z]{2}-[a-zA-Z]{2})\.facebook\.com/(pages/[a-zA-Z0-9\.-]+/[0-9]+|[a-zA-Z0-9\.-]+)[/]?$
(assert (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://") (re.union (str.to_re "www") (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "-") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re ".facebook.com/") (re.union (re.++ (str.to_re "pages/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "/") (re.+ (re.range "0" "9"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-")))) (re.opt (str.to_re "/")) (str.to_re "\u{0a}"))))
; UI2Host\x3ADesktopUser-Agent\u{3a}\x2Fnotifier\x2F
(assert (not (str.in_re X (str.to_re "UI2Host:DesktopUser-Agent:/notifier/\u{0a}"))))
; <select(.|\n)*?selected(.|\n)*?>(.*?)</option>(.|\n)*?</select>
(assert (not (str.in_re X (re.++ (str.to_re "<select") (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "selected") (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re ">") (re.* re.allchar) (str.to_re "</option>") (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "</select>\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
