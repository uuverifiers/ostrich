(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <title>(.*?)</title>
(assert (str.in_re X (re.++ (str.to_re "<title>") (re.* re.allchar) (str.to_re "</title>\u{0a}"))))
; thereHost\x3Aselect\x2FGetwww\u{2e}2-seek\u{2e}com\u{2f}search
(assert (str.in_re X (str.to_re "thereHost:select/Getwww.2-seek.com/search\u{0a}")))
; /\/[a-z]{4}\.html\?i\=\d{6,7}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".html?i=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; \d{6}
(assert (not (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[0-9]*(\.)?[0-9]+$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
