(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[A-Z\d]{83}\u{3d}[A-Z\d]{10}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 83 83) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 10 10) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}")))))
; [ \t]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (str.to_re "\u{0a}")))))
; search\u{2e}imesh\u{2e}com\s+WatchDogupwww\.klikvipsearch\.com
(assert (str.in_re X (re.++ (str.to_re "search.imesh.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDogupwww.klikvipsearch.com\u{0a}"))))
; eveocczmthmmq\u{2f}omzlHello\x2E\x2Fasp\x2Foffers\.asp\?
(assert (str.in_re X (str.to_re "eveocczmthmmq/omzlHello./asp/offers.asp?\u{0a}")))
(check-sat)
