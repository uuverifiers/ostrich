(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}fdf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fdf/i\u{0a}")))))
; ((^((1[8-9]\d{2})|([2-9]\d{3}))(10|12|0?[13578])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))(11|0?[469])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))(0?2)(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)(0?2)(29)$)|(^([3579][26]00)(0?2)(29)$)|(^([1][89][0][48])(0?2)(29)$)|(^([2-9][0-9][0][48])(0?2)(29)$)|(^([1][89][2468][048])(0?2)(29)$)|(^([2-9][0-9][2468][048])(0?2)(29)$)|(^([1][89][13579][26])(0?2)(29)$)|(^([2-9][0-9][13579][26])(0?2)(29)$))
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "1") (re.range "8" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.union (str.to_re "10") (str.to_re "12") (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8")))) (re.union (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")))) (re.++ (re.union (re.++ (str.to_re "1") (re.range "8" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.union (str.to_re "11") (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9")))) (re.union (str.to_re "30") (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")))) (re.++ (re.union (re.++ (str.to_re "1") (re.range "8" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.union (re.++ (str.to_re "2") (re.range "0" "8")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (str.to_re "29") (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8")) (str.to_re "00") (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (str.to_re "29") (re.union (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6")) (str.to_re "00") (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (str.to_re "291") (re.union (str.to_re "8") (str.to_re "9")) (str.to_re "0") (re.union (str.to_re "4") (str.to_re "8")) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (str.to_re "29") (re.range "2" "9") (re.range "0" "9") (str.to_re "0") (re.union (str.to_re "4") (str.to_re "8")) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (str.to_re "291") (re.union (str.to_re "8") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8")) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (str.to_re "29") (re.range "2" "9") (re.range "0" "9") (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8")) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (str.to_re "291") (re.union (str.to_re "8") (str.to_re "9")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6")) (re.opt (str.to_re "0")) (str.to_re "2")) (re.++ (str.to_re "29") (re.range "2" "9") (re.range "0" "9") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6")) (re.opt (str.to_re "0")) (str.to_re "2"))) (str.to_re "\u{0a}")))))
; /STOR\u{20}PIC\u{5f}\d{6}[a-z]{2}\u{5f}\u{20}\u{5f}\d{7}\u{20}\u{2e}\d{3}/i
(assert (not (str.in_re X (re.++ (str.to_re "/STOR PIC_") ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "_ _") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re " .") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/i\u{0a}")))))
; \u{28}\u{29}\s+WatchDog\sNetspy\d+pjpoptwql\u{2f}rlnjX-Mailer\u{3a}Host\u{3a}snprtz\x7Cdialnoref\x3D\u{25}user\x5Fid
(assert (str.in_re X (re.++ (str.to_re "()") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDog") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Netspy") (re.+ (re.range "0" "9")) (str.to_re "pjpoptwql/rlnjX-Mailer:\u{13}Host:snprtz|dialnoref=%user_id\u{0a}"))))
(check-sat)