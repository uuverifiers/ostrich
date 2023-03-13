(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}docx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".docx/i\u{0a}")))))
; Hourspjpoptwql\u{2f}rlnjFrom\x3Asbver\u{3a}Ghost
(assert (not (str.in_re X (str.to_re "Hourspjpoptwql/rlnjFrom:sbver:Ghost\u{13}\u{0a}"))))
; ^(.|\n){0,16}$
(assert (str.in_re X (re.++ ((_ re.loop 0 16) (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))))
; v\x2E\s+ocllceclbhs\u{2f}gth\w+http\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (str.in_re X (re.++ (str.to_re "v.") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ocllceclbhs/gth") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "http://www.searchinweb.com/search.php?said=bar\u{0a}"))))
(check-sat)
