(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; whenu\x2Ecom\d+Agent\stoWebupdate\.cgithisHost\u{3a}connection
(assert (not (str.in_re X (re.++ (str.to_re "whenu.com\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "Agent") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toWebupdate.cgithisHost:connection\u{0a}")))))
; Toolbarverpop\x2Epopuptoast\x2Ecomtvshowticketscount\x2Eyok\x2Ecom
(assert (not (str.in_re X (str.to_re "Toolbarverpop.popuptoast.comtvshowticketscount.yok.com\u{0a}"))))
; ^[1-9]{1}$|^[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}$|^9999$
(assert (str.in_re X (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "9999\u{0a}"))))
; /^\/\d+\/\d\.zip$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re "/") (re.range "0" "9") (str.to_re ".zip/U\u{0a}")))))
; From\x3A\w+SoftActivity\d+
(assert (str.in_re X (re.++ (str.to_re "From:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "SoftActivity\u{13}") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
