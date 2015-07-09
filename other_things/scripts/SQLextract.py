#!/usr/bin/env python2
# -*- coding: UTF-8 -*-
import sys, os, sqlite3
import encodings
from cStringIO import StringIO

home = os.environ.get("HOME")
db = "%s/rollback/rollback.sqlite" % (home)

#[id=16000;actor=crabman;type=2;list=main,index=13,add=1, stacknode=default:glass,stackquantity=9,nodemeta=0;x=None, y=None,z=None,oldnode=,oldparam1=None,oldparam2=None,oldmeta=None:newnode=,newparam1=None,newparam2=None,newmeta=None]

class Convert_id(object):
        def __init__(self, base):
                self.__players = dict()
                self.__nodes = dict()
                try:
                        conn = sqlite3.connect(db)
                        cur = conn.cursor()
                except Exception as err:
                        print(err)
                        print("problème avec la base de données")
                        sys.exit(1)
                else:
                        try:
                                cur.execute("SELECT * from actor")
                        except sqlite3.OperationalError as err:
                                print(err)
                        else:
                                result = cur.fetchall()
                                for res in result:
                                        self.__players[res[0]] = res[1][len("player:"):]
                        try:
                                cur.execute("SELECT * from node")
                        except sqlite3.OperationalError as err:
                                print(err)
                        else:
                                result = cur.fetchall()
                                for res in result:
                                        self.__nodes[res[0]] = res[1]
                finally:
                        cur.close()
                        conn.close()

        def get_player_name(self, player_id):
                if self.__players.has_key(player_id):
                        return self.__players[player_id]
                else:
                        return("")

        def get_node_name(self, node_id):
                if self.__nodes.has_key(node_id):
                        return self.__nodes[node_id]
                else:
                        return("")
########################################################################
## Utilities
#

def ston(a):
        """
                Returns a string equal to a or None
        """
        if a:
                return str(a)
        else:
                return ""
def select_all_nodes(stamp):
        try:
                conn = sqlite3.connect(db)
                conn.text_factory = str
                cur = conn.cursor()
        except sqlite3.OperationalError as err:
                print(err)
                sys.exit(1)
        try:
                cur.execute("SELECT * FROM action WHERE timestamp >=:stamp", {"stamp":stamp})
        except sqlite3.OperationalError as err:
                print(err)
                sys.exit(1)
        else:
                result = cur.fetchall()
        finally:
                cur.close()
                conn.close()
        return(result)

# Big-endian!!!
def readU16(strm):
        return (ord(strm.read(1)) << 16) + (ord(strm.read(1)))

def readU32(strm):
        return (ord(strm.read(1)) << 24) + (ord(strm.read(1)) << 16) + (ord(strm.read(1)) << 8) + (ord(strm.read(1)))

def decode(chaine):
        if not chaine :
                return "[]"
        else:
                strm = StringIO(chaine)
                table = "["
                nEntries = readU32(strm)
                for n in range(nEntries):
                    keyLen = readU16(strm)
                    key = strm.read(keyLen)
                    valLen = readU32(strm)
                    val = strm.read(valLen)
                    # Beware of potential quotes in meta, they must be escaped
                    # Fortunately their escape codes are the same in Python and Lua
                    # (and pretty much every language influenced by C)
                    # ------------
                    # Attention aux potentiels quotes dedans les meta, il faut les escape
                    # Heureusement leur mode d'escape est quasi le même en Python que Lua
                    table += '%s="%s"' % (key, val.encode('string-escape').replace('"', '\\"'))
                    if n != nEntries-1:
                        table += ", "
                table += "]"
                return table



def to_table(node):
        # Init bracket and basic datas
        table = '['
        table += 'id=%d' % node[0]
        table += ', actor="%s"' % Id.get_player_name(node[1])
        table += ', type=%d' % node[3]
        # Inventory Manipulation
        table += ', list="%s"' % ston(node[4])
        table += ', index="%s"' % ston(node[5])
        table += ', add="%s"' % ston(node[6])
        table += ', stacknode="%s"' % Id.get_node_name(node[7])
        table += ', stackquantity="%s"' % ston(node[8])
        table += ', nodemeta=%s' % ston(node[9])
        # Position
        table += ', x=%s, y=%s, z=%s' % (node[10], node[11], node[12])
        # Old node
        table += ', oldnode="%s"' % Id.get_node_name(node[13])
        table += ', oldparam1="%s"' % node[14]
        table += ', oldparam2="%s"' % ston(node[15])
        table += ', oldmeta=%s' % decode(node[16])
        # New node
        table += ', newnode="%s"' % Id.get_node_name(node[17])
        table += ', newparam1="%s"' % ston(node[18])
        table += ', newparam2="%s"' % ston(node[19])
        table += ', newmeta=%s' % decode(node[20])
        # Ending
        table += ']\n'
        return (table)

def write_list(nodes):
        try:
                name = "database-output.txt"
                f = open(name, "w")
        except Exception as err:
                print(err)
                sys.exit(1)

        for node in nodes:
                table = to_table(node)
                f.write(table)
        f.close()


########################################################################
## Main
#

if __name__ == '__main__':
        Id = Convert_id(db)
        #select all nodes player as set i where time >= time
        all_nodes = select_all_nodes(0) #1418613979)

        # write in file
#        for x in range(0,len(all_nodes)):
#                print(all_nodes[x])
        write_list(all_nodes)

