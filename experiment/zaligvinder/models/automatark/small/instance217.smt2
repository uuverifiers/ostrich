(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; engineResultUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "engineResultUser-Agent:\u{0a}"))))
; ^(GB)?(\ )?[0-9]\d{2}(\ )?[0-9]\d{3}(\ )?(0[0-9]|[1-8][0-9]|9[0-6])(\ )?([0-9]\d{2})?|(GB)?(\ )?GD(\ )?([0-4][0-9][0-9])|(GB)?(\ )?HA(\ )?([5-9][0-9][0-9])$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "GB")) (re.opt (str.to_re " ")) (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.range "0" "9") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (re.range "1" "8") (re.range "0" "9")) (re.++ (str.to_re "9") (re.range "0" "6"))) (re.opt (str.to_re " ")) (re.opt (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (re.opt (str.to_re "GB")) (re.opt (str.to_re " ")) (str.to_re "GD") (re.opt (str.to_re " ")) (re.range "0" "4") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.opt (str.to_re "GB")) (re.opt (str.to_re " ")) (str.to_re "HA") (re.opt (str.to_re " ")) (str.to_re "\u{0a}") (re.range "5" "9") (re.range "0" "9") (re.range "0" "9")))))
; myway\.comzmnjgmomgbdz\u{2f}zzmw\.gztUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "myway.comzmnjgmomgbdz/zzmw.gztUser-Agent:\u{0a}"))))
; /\u{2e}paq8o([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.paq8o") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; (ISBN[-]*(1[03])*[ ]*(: ){0,1})*(([0-9Xx][- ]*){13}|([0-9Xx][- ]*){10})
(assert (str.in_re X (re.++ (re.* (re.++ (str.to_re "ISBN") (re.* (str.to_re "-")) (re.* (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "3")))) (re.* (str.to_re " ")) (re.opt (str.to_re ": ")))) (re.union ((_ re.loop 13 13) (re.++ (re.union (re.range "0" "9") (str.to_re "X") (str.to_re "x")) (re.* (re.union (str.to_re "-") (str.to_re " "))))) ((_ re.loop 10 10) (re.++ (re.union (re.range "0" "9") (str.to_re "X") (str.to_re "x")) (re.* (re.union (str.to_re "-") (str.to_re " ")))))) (str.to_re "\u{0a}"))))
(check-sat)
